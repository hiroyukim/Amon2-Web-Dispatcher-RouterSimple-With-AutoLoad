package Amon2::Web::Dispatcher::RouterSimple::With::AutoLoad;
use strict;
use warnings;
our $VERSION = '0.01';
use Class::Load;
use parent 'Amon2::Web::Dispatcher::RouterSimple';

sub _dispatch {
    my ($class, $c) = @_;
    my $req = $c->request;
    if (my $p = $class->match($req->env)) {
        my $action = $p->{action};
        $c->{args} = $p;
        my $module = "@{[ ref Amon2->context ]}::C::$p->{controller}";
        Class::Load::load_class($module);
        $module->$action($c, $p);
    } else {
        $c->res_404();
    }
}

1;
__END__

=head1 NAME

Amon2::Web::Dispatcher::RouterSimple::With::AutoLoad -

=head1 SYNOPSIS

  use Amon2::Web::Dispatcher::RouterSimple::With::AutoLoad;

=head1 DESCRIPTION

Amon2::Web::Dispatcher::RouterSimple::With::AutoLoad is

=head1 AUTHOR

Default Name E<lt>default {at} example.comE<gt>

=head1 SEE ALSO

=head1 LICENSE

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut
