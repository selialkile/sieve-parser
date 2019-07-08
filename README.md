<<<<<<< Updated upstream:README
                           Ruby/SieveParser
                           ~~~~~~~~~~~~~~~~

=======
[![Build Status](https://travis-ci.com/selialkile/sieve-parser.svg)](https://travis-ci.org/selialkile/sieve-parser)

# Ruby/SieveParser
>>>>>>> Stashed changes:README.md

0. INTRODUCTION
1. REQUIREMENTS
2. INSTALLATION
3. LICENSE
4. AUTHOR
5. REFERENCES


0. INTRODUCTION
===============

sieve-parser is a pure-ruby implementation for parsing and manipulate the sieve scripts.


1. REQUIREMENTS
===============

Ruby/SieveParser requires Ruby version 1.9.1 or newer.


2. INSTALLATION
===============

gem install sieve-parser


3. LICENSE
==========

Copyright (c) 2012 Thiago Coutinho <thiago@osfeio.com>
<thiago.coutinho@locaweb.com.br>

Permission to use, copy, modify, and distribute this software for any
purpose with or without fee is hereby granted, provided that the above
copyright notice and this permission notice appear in all copies.

THE SOFTWARE IS PROVIDED "AS IS" AND THE AUTHOR DISCLAIMS ALL WARRANTIES
WITH REGARD TO THIS SOFTWARE INCLUDING ALL IMPLIED WARRANTIES OF
MERCHANTABILITY AND FITNESS. IN NO EVENT SHALL THE AUTHOR BE LIABLE FOR
ANY SPECIAL, DIRECT, INDIRECT, OR CONSEQUENTIAL DAMAGES OR ANY DAMAGES
WHATSOEVER RESULTING FROM LOSS OF USE, DATA OR PROFITS, WHETHER IN AN
ACTION OF CONTRACT, NEGLIGENCE OR OTHER TORTIOUS ACTION, ARISING OUT OF
OR IN CONNECTION WITH THE USE OR PERFORMANCE OF THIS SOFTWARE.


4. AUTHOR
=========

Ruby/SieveParser was developed by Thiago Coutinho in Locaweb
(http://www.locaweb.com.br).


5. REFERENCES
=============

[1] http://www.faqs.org/rfcs/rfc3028.html
[2] http://www.faqs.org/rfcs/rfc5804.html
[3] http://www.faqs.org/rfcs/rfc5230.html
[4] http://www.faqs.org/rfcs/rfc5229.html

6. LAST CHANGES
===============

[0.0.6]
 - require 'split-where'
 - Sieve::Conditions => Parse new types and spliter more faster without regex
 - Examples:
    # header :contains "Subject" "lala"
    # not header :contains "Subject" "popo"
    # not exists "Subject"
    # exists "Subject"
    # header :count "ge" :comparator "i;ascii-numeric" "Subject" "1"
    # header :count "gt" :comparator "i;ascii-numeric" "Subject" "3"
    # header :count "lt" :comparator "i;ascii-numeric" "Subject" "5"
    # header :count "eq" :comparator "i;ascii-numeric" "Subject" "7"
    # header :value "gt" :comparator "i;ascii-numeric" "Subject" "9"
    # header :value "eq" :comparator "i;ascii-numeric" "Subject" "11"
