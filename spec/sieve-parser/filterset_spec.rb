# -*- encoding : utf-8 -*-
require 'spec_helper'

module Sieve
  describe FilterSet do
    let(:filterset_text) {
%Q{require ["fileinto","relational","comparator-i;ascii-numeric","copy","vacation"];
# rule:[nome_teste]
if header :contains "Subject" "teste"
{
\tfileinto "INBOX.rascunho";
\tstop;
}
# rule:[nome2]
if anyof (header :contains "Subject" "lala", not header :contains "Subject" "popo", header :count "gt" :comparator "i;ascii-numeric" "Subject" "4", not exists "Subject", exists "Subject", header :count "ge" :comparator "i;ascii-numeric" "Subject" "2")
{
\tfileinto "INBOX";
\tfileinto :copy "INBOX.lixo";
\tstop;
}
# rule:[nome_all]
if anyof (header :contains "From" "all", header :contains "aaaaa" "333")
{
\tfileinto :copy "INBOX.lixo";
\tredirect :copy "lala@teste.com";
\tredirect "eduardo.lipolis@locaweb.com.br";
\tstop;
}
# rule:[nome all rules]
if allof (header :contains "Subject" "asdf", header :contains "From" "vvvvv", header :contains "To" "vvvvv")
{
\tfileinto :copy "INBOX.rascunho";
\tredirect :copy "lala@teste.com";
\tdiscard;
\tstop;
}
# rule:[autoresposta]
if true
{
\tvacation :days 1 :subject "nao estou..." :mime text:
Content-Type: text/html;

<p>se precisar de mim, chama o <span style="text-decoration: underline;"><em><strong>batman</strong></em></span>...</p><p>eu realmente nao estou.. chama outro...</p><p>para de me amolar...xD</p>
.
;
}
#redirect
if true
{
\t
}
# redirect
if true
{
\tredirect :copy;
}
}
}

    let(:filterset_text_test) {
%Q{require ["copy","vacation"];
# redirect
if true
{
\tredirect :copy "redirect2@teste.com";
\tredirect :copy "redirect@teste.com";
\tredirect :copy "redirect3@teste.com";
\tredirect :copy "redirect4@teste.com";
\tredirect :copy "redirect5@teste.com";
\tredirect :copy "redirect6@teste.com";
\tredirect :copy "redirect7@teste.com";
\tredirect :copy "redirect8@teste.com";
\tredirect :copy "redirect9@teste.com";
\tredirect :copy "redirect10@teste.com";
\tredirect :copy "redirect11@teste.com";
\tredirect :copy "redirect12@teste.com";
\tredirect :copy "redirect13@teste.com";
\tredirect :copy "test@xxx.com.br";
}
# AutoReply
if true
{
\tvacation :days 1 :subject "teste ggsubject" :mime text:
Content-Type: text/html;

&nbsp;&nbsp;&nbsp;&nbsp;lala<br>popo&nbsp;&nbsp;&nbsp;&nbsp;lala
.
;
\tredirect :copy "thiagso@osfeio.com";
}
}
}
    let(:filterset_many_filters_else) {
%Q{require ["fileinto"];
# wtf
if header :is "Sender" "owner-ietf-mta-filters@imc.org"
{
\tfileinto "filter"; # move to "filter" mailbox
}
elsif address :DOMAIN :is ["From", "To"] "example.com"
{
\tkeep;                # keep in "In" mailbox
}
elsif anyof (NOT address :all :contains ["To", "Cc", "Bcc"] "me@example.com", header :matches "subject" ["*make*money*fast*", "*university*dipl*mas*"])
{
\tfileinto "spam";    # move to "spam" mailbox
}
else
{
\tfileinto "personal";
}
}
}
    context ".new" do
      context "given a success" do
        subject{Sieve::FilterSet.new(filterset_text)}
        it "should return a object of filterset" do
          subject.class.to_s.should == "Sieve::FilterSet"
        end

        it "should have requires" do
          subject.requires.count.should == 5
        end

        it "should have filters" do
          subject.filters.count.should == 7
        end
      end

      context "given a failure" do
        xit "should return a error if use a bad text of sieve" do
        end
      end
    end

    context "#to_s" do
          let(:filterset_text_to_s) {
%Q{require ["fileinto","relational","comparator-i;ascii-numeric","copy","vacation"];
# rule:[nome_teste]
if header :contains "Subject" "teste"
{
\tfileinto "INBOX.rascunho";
\tstop;
}
# rule:[nome_all]
if anyof (header :contains "From" "all", header :contains "aaaaa" "333")
{
\tfileinto :copy "INBOX.lixo";
\tredirect :copy "lala@teste.com";
\tredirect "eduardo.lipolis@locaweb.com.br";
\tstop;
}
# rule:[nome all rules]
if allof (header :contains "Subject" "asdf", header :contains "From" "vvvvv", header :contains "To" "vvvvv")
{
\tfileinto :copy "INBOX.rascunho";
\tredirect :copy "lala@teste.com";
\tdiscard;
\tstop;
}
}
}
      context "given a success with get text of filterset" do
        subject{Sieve::FilterSet.new(filterset_text_to_s)}
        it "should return a text" do
          subject.to_s.should == filterset_text_to_s
        end
      end

      context "given a success with get text of filterset test" do
        subject{Sieve::FilterSet.new(filterset_text_test)}
        it "should return a text" do
          subject.to_s.should == filterset_text_test
        end
      end

      context "given a success to get text of filterset with many filters conditions" do
        subject{Sieve::FilterSet.new(filterset_many_filters_else)}
        it "should return a text" do
          subject.to_s.should == filterset_many_filters_else
        end
      end
    end

    context "#add_filter" do
      context "given a success" do
        subject{Sieve::FilterSet.new()}

        it "should add new filter" do
          subject.add_filter(Sieve::Filter.new())
          subject.filters.count.should == 1
        end
      end

      context "given a failure" do
        subject{Sieve::FilterSet.new()}

        it "should raise" do
          expect{subject.add_filter(Sieve::Action.new())}.to raise_error("The param is not a Filter!")
        end
      end
    end

    context "#add_require" do
      context "given a success" do
        subject{Sieve::FilterSet.new()}

        it "should add new filter" do
          subject.add_require("fileinto")
          subject.requires.count.should == 1
        end
      end

      context "given a failure" do
        subject{Sieve::FilterSet.new()}

        it "should raise" do
          expect{subject.add_require(0435)}.to raise_error("Is not a require valid!")
        end
      end
    end

    context "#find_filter_by_name" do
      subject{Sieve::FilterSet.new()}

      context "given a success with find filter" do

        it "should find filter" do
          filter = Sieve::Filter.new(:name => "myname")
          filter2 = Sieve::Filter.new(:name => "myname2")
          subject.add_filter(filter)
          subject.add_filter(filter2)
          subject.find_filter_by_name("myname2").name.should == "myname2"
        end
      end

      context "given a failure" do
        it "should raise" do
          expect{subject.find_filter_by_name("myname332")}.to raise_error(SieveErrors::FilterNotFound)
        end
      end
    end

    context "#filter_index_by_name" do
      subject{Sieve::FilterSet.new()}

      context "given a success with find filter index" do

        it "should find filter" do
          filter = Sieve::Filter.new(:name => "myname")
          filter2 = Sieve::Filter.new(:name => "myname2")
          subject.add_filter(filter)
          subject.add_filter(filter2)
          subject.filter_index_by_name("myname2").should == 1
        end
      end

      context "given a failure" do
        it "should raise" do
          expect{subject.filter_index_by_name("myname2")}.to raise_error(SieveErrors::FilterNotFound)
        end
      end
    end

    context "#remove_filter_by_name" do
      subject{Sieve::FilterSet.new()}

      context "given a success with find filter index" do

        it "should find filter" do
          filter = Sieve::Filter.new(:name => "myname")
          filter2 = Sieve::Filter.new(:name => "myname2")
          subject.add_filter(filter)
          subject.add_filter(filter2)
          subject.remove_filter_by_name("myname2").should be_true
        end
      end

      context "given a failure" do
        it "should raise" do
          expect{subject.remove_filter_by_name("mynamess")}.to raise_error(SieveErrors::FilterNotFound)
        end
      end
    end


  end
end