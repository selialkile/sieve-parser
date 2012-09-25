# -*- encoding : utf-8 -*-
require 'spec_helper'

module Sieve
  describe Condition do
    let(:conditions_text) {[ 
        %q{true} ,
        %q{header :contains "Subject" "teste"} ,
        %q{not header :contains "Subject" "teste"} ,
        %q{header :contains "From" "all", header :contains "aaaaa" "333"} ,
        %q{header :contains "Subject" "lala", not header :contains "Subject" "popo", header :count "gt" :comparator "i;ascii-numeric" "Subject" "4", not exists "Subject", exists "Subject", header :count "ge" :comparator "i;ascii-numeric" "Subject" "2" } ,
        %q{xpto :contains "Subject" "teste,", not header :is "Subject" "lala," } ,
        %q{xpto :contains "Subject" "São Paulo,", not header :is "Subject" "lala," } ,
    ]}
    context "#new" do
      context "given a success with new object'" do
        subject{Sieve::Condition.new()}

        it 'should be create' do
          subject.class.to_s.should == "Sieve::Condition"
        end
      end

      context "given a success with condition of all messages(true)" do
        subject{Sieve::Condition.new(conditions_text[0])}

        it 'should have a test attribute' do
          subject.test.should == "true"
        end
      end

      context "given a success with one condition" do
        subject{Sieve::Condition.new(conditions_text[1])}

        it "dont should have not" do
          subject.not.should == nil
        end

        it 'should have a test attribute' do
          subject.test.should == "header"
        end

        it "should have type" do
          subject.type.should == ":contains"
        end

        it "should have arg1" do
          subject.arg1.should == "Subject"
        end

        it "should have arg2" do
          subject.arg2.should == "teste"
        end
      end

      context "given a success with one condition with not" do
        subject{Sieve::Condition.new(conditions_text[2])}

        it "dont should have not" do
          subject.not.should == "not"
        end

        it 'should have a test attribute' do
          subject.test.should == "header"
        end

        it "should have type" do
          subject.type.should == ":contains"
        end

        it "should have arg1" do
          subject.arg1.should == "Subject"
        end

        it "should have arg2" do
          subject.arg2.should == "teste"
        end
      end

      context "given a success with two conditions " do
        subject{Sieve::Condition.parse_all(conditions_text[3])}

        it "should return a array with 2 itens of conditions" do
          subject.count.should == 2
        end
      end

      context "given a success with many conditions " do
        subject{Sieve::Condition.parse_all(conditions_text[4])}

        xit "should return a array with 6 conditions" do
          #ajustar o parse para condicoes mais especificas
          subject.count.should == 6
        end
      end

      context "given a success with many conditions, but have comma in text of condition " do
        # header :contains "Subject" "teste,", not header :is "Subject" "lala,"
        subject{Sieve::Condition.parse_all(conditions_text[5])}

        it "should return a array with 2 conditions" do
          subject.count.should == 2
        end

        it 'should have a test attribute on first object' do
          subject[0].test.should == "xpto"
        end

        it "should have type on first object" do
          subject[0].type.should == ":contains"
        end

        it "should have arg1 on first object" do
          subject[0].arg1.should == "Subject"
        end

        it "should have arg2 on first object" do
          subject[0].arg2.should == "teste,"
        end

      end

      context "given a success with many conditions, but have comma and special caracters in text of condition " do
        # header :contains "Subject" "teste,", not header :is "Subject" "lala,"
        subject{Sieve::Condition.parse_all(conditions_text[6])}

        it "should return a array with 2 conditions" do
          subject.count.should == 2
        end

        it 'should have a test attribute on first object' do
          subject[0].test.should == "xpto"
        end

        it "should have type on first object" do
          subject[0].type.should == ":contains"
        end

        it "should have arg1 on first object" do
          subject[0].arg1.should == "Subject"
        end

        it "should have arg2 on first object" do
          subject[0].arg2.should == "São Paulo,"
        end

      end
    end

    context "#to_s" do
      context "given a success with get text of condition" do
        subject{Sieve::Condition.new(conditions_text[1])}
        it "should return a text" do
          subject.to_s.should == %q{header :contains "Subject" "teste"}
        end
      end
      context "given a success with get text of condition of true" do
        subject{Sieve::Condition.new(conditions_text[0])}
        it "should return a text" do
          subject.to_s.should == "true"
        end
      end
    end
  end
end