class Nift < Formula
  desc "Cross-platform open source framework for managing and generating websites"
  homepage "https://nift.cc/"
  url "https://github.com/nifty-site-manager/nsm/archive/v2.3.3.tar.gz"
  sha256 "08bc3662b955bbd3783410cc782f802f1f08b267be08112c5c4ef0d7ecad19b3"

  bottle do
    cellar :any_skip_relocation
    sha256 "62447fcf5716a36d25c14c8e44ad7e3adf8c7094c8ba8d3db4cf39048e815aa7" => :catalina
    sha256 "7f93e0b9b17fca50d768af26ee54270930da440f2aca473b14a617b448afb3a6" => :mojave
    sha256 "08df3eac05928997b1b3525afaf1daf0c9bea770e4d5d0a6de1cbce959149bfc" => :high_sierra
  end

  def install
    system "make"
    system "make", "install", "PREFIX=#{prefix}"
  end

  test do
    mkdir "empty" do
      system "#{bin}/nsm", "init", ".html"
      assert_predicate testpath/"empty/output/index.html", :exist?
    end
  end
end
