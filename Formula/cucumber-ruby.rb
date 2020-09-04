class CucumberRuby < Formula
  desc "Cucumber for Ruby"
  homepage "https://cucumber.io"
  url "https://github.com/cucumber/cucumber-ruby/archive/v5.1.1.tar.gz"
  sha256 "a2dded4fe9e629a2925e74f00e1c7c24dd2f08ea17f4474c2332052d73788acd"
  license "MIT"

  bottle do
    sha256 "d0d4ed2b0173d6c6486dc2644cbf9f07e08955bba983d6545e3386c22b8a5c70" => :catalina
    sha256 "7de9f5b999e9aaee312dec0da786cc81595aa237952774f0bf5fdeb7e14160dd" => :mojave
    sha256 "df11217ec56628eff8562cdf7d1fd0ae318e7fadcdef27605013e2b40aab4090" => :high_sierra
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
