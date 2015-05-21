#!/usr/bin/env perl

use strict;
use warnings;

use utf8;

# Disable epoll, kqueue and IPv6
BEGIN { $ENV{MOJO_POLL} = $ENV{MOJO_NO_IPV6} = 1 }

use Test::More;
use Test::Mojo;
use Mojolicious::Lite;
plugin 'DevexpressHelpers';
app->log->level('error'); #silence

# routes
get '/' => 'index';
get '/with_type' => 'with_type';

# Test
my $t = Test::Mojo->new;

# GET / default
$t->get_ok('/')
  ->status_is(200)
  ->element_exists('html body div[id=dxctl1]')
  ->text_is('script' => q{$(function(){$("#dxctl1").dxButton({onClick: "\/action\/button1",
text: "Test button"});});});

$t->get_ok('/with_type')
  ->status_is(200)
  ->element_exists('html body div[id=myButtonId]')
  ->text_is('script' => q{$(function(){$("#myButtonId").dxButton({onClick: "\/action\/button1",
text: "Test danger button",
type: "danger"});});});

done_testing;

__DATA__
@@ index.html.ep
% layout 'main';
%= dxbutton undef, 'Test button' => '/action/button1'

@@ with_type.html.ep
% layout 'main';
%= dxbutton 'myButtonId' => 'Test danger button' => '/action/button1', { type => 'danger' }

@@ layouts/main.html.ep
<!doctype html>
<html>
    <head>
       <title>Test</title>
    </head>
    <body><%== content %>
%= dxbuild
</body>
</html>