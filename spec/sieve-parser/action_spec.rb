# -*- encoding : utf-8 -*-
require 'spec_helper'

module Sieve
  describe Action do
    let(:actions_text) {  [ 
      %q{fileinto :copy "INBOX.rascunho";},
      %q{redirect :copy "lala@teste.com";},
      %q{discard;},
      %q{stop;}
    ]}
    context "#new" do
      context "given a success with new object'" do
        subject{Sieve::Action.new()}

        it 'should be create' do
          subject.class.to_s.should == "Sieve::Action"
        end
      end

      context "given a success with type 'fileinto'" do
        subject{Sieve::Action.new(actions_text[0])}

        it 'should have a type' do
          subject.type.should == "fileinto"
        end

        it "should have copy" do
          subject.copy.should == true
        end

        it "should have target" do
          subject.target.should == "INBOX.rascunho"
        end
      end

      context "given a success with type 'redirect'" do
        subject{Sieve::Action.new(actions_text[1])}

        it 'should have a type' do
          subject.type.should == "redirect"
        end

        it "should have copy" do
          subject.copy.should == true
        end

        it "should have target" do
          subject.target.should == "lala@teste.com"
        end
      end

      context "given a success with type 'discard'" do
        subject{Sieve::Action.new(actions_text[2])}

        it 'should have a type' do
          subject.type.should == "discard"
        end

        it "should dont have copy" do
          subject.copy.should == nil
        end

        it "should dont have target" do
          subject.target.should == nil
        end
      end

      context "given a success with type 'stop'" do
        subject{Sieve::Action.new(actions_text[3])}

        it 'should have a type' do
          subject.type.should == "stop"
        end

        it "should dont have copy" do
          subject.copy.should == nil
        end

        it "should dont have target" do
          subject.target.should == nil
        end
      end

      context "given a failure" do
      end
    end

    context ".parse_all" do
      let(:all_actions_text) {
        %q{fileinto :copy "INBOX.rascunho";
        redirect :copy "lala@teste.com";
        discard;
        stop;}
      }
      context "given a success with type 'fileinto'" do
        subject{Sieve::Action.parse_all(all_actions_text)}

        it 'should have array of actions' do
          subject.count.should == 4
        end
      end
    end

    context "#to_s" do
      context "given a success with get text of action of fileinto" do
        subject{Sieve::Action.new(actions_text[0])}
        it "should return a text" do
          subject.to_s.should == "fileinto :copy \"INBOX.rascunho\";"
        end
      end
      context "given a success with get text of action of stop" do
        subject{Sieve::Action.new(actions_text[3])}
        it "should return a text" do
          subject.to_s.should == "stop;"
        end
      end
    end
  end
end