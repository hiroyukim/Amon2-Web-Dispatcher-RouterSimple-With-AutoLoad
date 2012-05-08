package Amon2::Web::Dispatcher::RouterSimple::With::AutoLoad;
use strict;
use warnings;
our $VERSION = '0.01';
use Class::Load;
use Router::Simple 0.03;

#xxx copy from Amon2::Web::Dispatcher::RouterSimple
sub import {
    my $class = shift;
    my %args = @_;
    my $caller = caller(0);

    my $router = Router::Simple->new();

    no strict 'refs';
    # functions
    *{"${caller}::connect"} = sub {
        if (@_ == 2 && !ref $_[1]) {
            my ($path, $dest_str) = @_;
            my ($controller, $action) = split('#', $dest_str);
            my %dest;
            $dest{controller} = $controller;
            $dest{action} = $action if defined $action;
            $router->connect($path, \%dest);
        } else {
            $router->connect(@_);
        }
    };
    *{"${caller}::submapper"} = sub {
        $router->submapper(@_);
    };
    # class methods
    *{"${caller}::router"} = sub { $router };
    for my $meth (qw/match as_string/) {
        *{"$caller\::${meth}"} = sub {
            my $self = shift;
            $router->$meth(@_)
        };
    }
    *{"$caller\::dispatch"} = \&_dispatch;
}

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
