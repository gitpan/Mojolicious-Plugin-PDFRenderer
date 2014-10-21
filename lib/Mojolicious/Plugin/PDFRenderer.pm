package Mojolicious::Plugin::PDFRenderer;
use Mojo::Base 'Mojolicious::Plugin';
use Mojo::JSON qw/decode_json/;

sub register {
    my ( $self, $app, $opts ) = @_;
    # writing it now...
}

# ABSTRACT: 
1;

__END__

=pod

=encoding UTF-8

=head1 NAME

Mojolicious::Plugin::PDFRenderer -  

=head1 VERSION

version 0.01

=head1 SYNOPSIS

    package App;
    use Mojo::Base 'Mojolicious';

    sub startup {
        my $self = shift;

        $self->plugin( 'Mojolicious::Plugin::PDFRenderer' );
        # ...
    }

Then go to http://yourapp:3000/any/route, take a good look, then go to http://yourapp:3000/any/route.pdf. Cool, huh?

=head1 REQUIREMENTS

=over 2

=item L<PDF::WebKit>

=item L<"wkhtmltopdf"|http://wkhtmltopdf.org/>

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
