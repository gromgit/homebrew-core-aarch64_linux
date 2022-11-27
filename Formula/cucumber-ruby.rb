class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v8.0.0.tar.gz"
  sha256 "5e382fc00fd04842813f58c7c7a1b43c2ddf6a8e5c53ae9916daba95462cdb6a"
  license "MIT"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/cucumber-ruby"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "78b944db9c06ee4fe3c14558813a3819f4d962017af0b01b099e3e74b72966a3"
  end

  depends_on "pkg-config" => :build

  uses_from_macos "libffi", since: :catalina
  uses_from_macos "ruby", since: :big_sur

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
