class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v5.1.2.tar.gz"
  sha256 "6e5295f79c919e5b1824c003fe6cab93a360c53b55938ecefa6aa2e71c8cf447"
  license "MIT"

  bottle do
    sha256 "6664287aeee18891e24d8f4191da1ee0af99912464e69ecf6d5d8d2ed972e9c5" => :catalina
    sha256 "fef11d374d55a4298dc1277b35d384565eb8bc1d5928da3b4995ac5deae8efd7" => :mojave
    sha256 "b18c9338b8d64c7b12ce9e5e6c264de23bd9235f49815825950bdc42868a8560" => :high_sierra
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :catalina

  def install
    ENV["GEM_HOME"] = libexec
    system "gem", "build", "cucumber.gemspec"
    system "gem", "install", "cucumber-#{version}.gem"
    bin.install libexec/"bin/cucumber"
    bin.env_script_all_files(libexec/"bin", GEM_HOME: ENV["GEM_HOME"])
  end

  test do
    assert_match "create   features", shell_output("#{bin}/cucumber --init")
    assert_predicate testpath/"features", :exist?
  end
end
