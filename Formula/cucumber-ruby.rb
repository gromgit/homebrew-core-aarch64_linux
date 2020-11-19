class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v5.2.0.tar.gz"
  sha256 "273c9d98c5de487d91a6f35f289dd305964611fd01d5080df346bd42f11fffba"
  license "MIT"

  bottle do
    sha256 "58a17b42e9f46239ca24c2afd3c54cadbf2b73dbf0b1f9499af37ac2b4399ace" => :big_sur
    sha256 "76c38db8edb1a3bdfd36c5e334c6e1c6bfd55f1c93f66719b1880aefe368228e" => :catalina
    sha256 "f1d76f4dc2da8f8e87911d3825b726050334437f65e473d4b581640a7c6a5b1d" => :mojave
    sha256 "81271d17f35e14fd259388bcbfc4d5ac0ab516a0a6ff5f003dc52d02421369a0" => :high_sierra
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
