package Mojolicious::Plugin::PDFRenderer;
use Mojo::Base 'Mojolicious::Plugin';
use PDF::WebKit;
use List::AllUtils qw/uniq/;

sub register {
    my ( $self, $app, $opts ) = @_;
    $opts->{ '-args-override' } //= 1 unless exists $opts->{ '-args-override' };
    my $args_override = delete $opts->{ '-args-override' };
    my @opts = `wkhtmltopdf --extended-help`;
       @opts = map { my $opt = $_; $opt =~ s/.*--([^ =,]+).*/$1/g; $opt =~ s/-/_/g; $opt =~ s/\W//g; $opt =~ s/_+$//g; $opt } grep { $_ =~ /--[^ =]+/ } @opts;
       @opts = uniq @opts;
    my %okay = map { $_ => 1 } @opts;
    $app->plugin( 'Mojolicious::Plugin::Args' ) if $args_override;
    $app->hook( around_action => sub {
        my ( $next, $c, $action, $last ) = @_;
        my $url  = $c->req->url->to_abs;
        return $next->() unless $c->stash->{format} and $c->stash->{format} eq 'pdf';
        $c->respond_to( pdf => sub {
            my $url  = $c->req->url->to_abs;
               $url =~ s/\.pdf.*$//i;

            $app->log->debug( "...fetching url $url for pdf" );

            my %opts = %{ $opts };
            do {
                my %args = $c->args;
                my @keys = grep { $okay{ $_ } } keys %args;
                $opts{ $_ } = $args{ $_ } for @keys;
                $app->log->debug( "pdf args override...", $app->dumper( \%opts ) ) if @keys;
            } if $args_override;
            my $kit = new PDF::WebKit ( $url, %opts );
            my $pdf = $kit->to_pdf;

            $c->res->headers->content_type( 'application/pdf' );
            $c->res->body( $pdf );
            $c->rendered( 200 );
        } );
    } );
}

# ABSTRACT: Uses wkhtmltopdf via PDF::WebKit to render your app exactly as it looks in Chrome/WebKit but vector scalable and in PDF.
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Mojolicious::Plugin::PDFRenderer - Uses wkhtmltopdf via PDF::WebKit to render your app exactly as it looks in Chrome/WebKit but vector scalable and in PDF.

=head1 VERSION

version 0.06

=head1 SYNOPSIS

    package App;
    use Mojo::Base 'Mojolicious';

    sub startup {
        my $self = shift;

        $self->plugin( 'Mojolicious::Plugin::PDFRenderer', {
            javascript_delay => 1000
            , load_error_handling => 'ignore'
            , page_height => '5in'
            , page_width => '10.5in'
            # options that would otherwise be passed to PDF::WebKit,
            # see `wkhtmltopdf --extended-help` for more (replace dashes w/ underscores)
        } );
        # ...
    }

Then go to http://yourapp:3000/any/route, take a good look, then go to http://yourapp:3000/any/route.pdf. Cool, huh?

=head1 REQUIREMENTS

=over 2

=item L<PDF::WebKit>

=item L<"wkhtmltopdf"|http://wkhtmltopdf.org/>

=item A preforking server instance running (e.g. ./script/app prefork [...] or ./script/app hypnotoad [...], etc) with at least 2
connections / workers available so that the extension can hit the back-end again, i.e. a request in a request.

=back

=head1 SEE ALSO

=over 2

=item Other cool stuff I've written

=back

=for :stopwords cpan testmatrix url annocpan anno bugtracker rt cpants kwalitee diff irc mailto metadata placeholders metacpan

=head1 SUPPORT

=head2 Bugs / Feature Requests

Please report any bugs or feature requests through the issue tracker
at L<https://github.com/sharabash/mojolicious-plugin-pdfrenderer/issues>.
You will be notified automatically of any progress on your issue.

=head2 Source Code

This is open source software.  The code repository is available for
public review and contribution under the terms of the license.

L<https://github.com/sharabash/mojolicious-plugin-pdfrenderer>

  git clone git://github.com/sharabash/mojolicious-plugin-pdfrenderer.git

=head1 AUTHOR

Nour Sharabash <amirite@cpan.org>

=head1 CONTRIBUTOR

Nour Sharabash <nour.sharabash@gmail.com>

=head1 COPYRIGHT AND LICENSE

This software is copyright (c) 2014 by Nour Sharabash.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=cut
