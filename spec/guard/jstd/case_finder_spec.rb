require "spec_helper"

describe Guard::Jstd::CaseFinder do
  def file1
   <<-CASES
      TestCase("First", {\][pw458asdf,vc]})
      TestCase (    "Second" , {/?';,~'})
    CASES
  end

  def file2
    <<-CASES
       TestCase('Second'    , {})
       TestCase('Third'    , {})
       TestCase("Fourth", {
         "test": function () {
           assert(false)
         }
       });
    CASES
  end

  describe ".find" do
    context "--given an array of paths--" do
      it "finds the TestCases in the corresponding files" do
        path = 'foo/bar.js'
        path2 = 'hand/foot.js'
        File.should_receive(:read).with(path) { file1 }
        File.should_receive(:read).with(path2) { file2 }
        subject.find([path, path2]).should == "First,Second,Third,Fourth"
      end
    end
  end
end
