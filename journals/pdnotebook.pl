#!/usr/bin/env perl
use v5.14.1;
use Pandoc::Filter;
use Pandoc::Elements;
use Encode 'decode_utf8';

pandoc_filter CodeBlock => sub {
    if ( $_->class eq 'sh' ) {
        my $cmd = $_->content;
        say STDERR $cmd;
        my $out = decode_utf8(`$cmd`);
        return Div attributes { class => 'cell code' },
          [
            $_,
            Div attributes { class => 'output stream stdout' },
            [ CodeBlock( attributes {}, $out ) ]
          ];
    }
  },
  Link => sub {
    if ( $_->url =~ /^([QP][0-9]+)$/ ) {
        $_->url("http://www.wikidata.org/entity/$1");
        return $_;
    }
  };
