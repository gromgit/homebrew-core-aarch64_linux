class Sourcery < Formula
  desc "Meta-programming for Swift, stop writing boilerplate code"
  homepage "https://github.com/krzysztofzablocki/Sourcery"
  url "https://github.com/krzysztofzablocki/Sourcery/archive/1.3.3.tar.gz"
  sha256 "edd44bea2620b65e990e69c30a0a717ec4e5626fb7a07bc999ac42b50de72489"
  license "MIT"
  head "https://github.com/krzysztofzablocki/Sourcery.git"

  bottle do
    sha256 cellar: :any, arm64_big_sur: "1b4480b268fc43adadefd3ee6375a43e5c3d442d5af73dbb2a039e28cf54a6a9"
    sha256 cellar: :any, big_sur:       "5cb91900806e044b6a2a89883f31c6ce83d3e5953f98f1c759c3d9b45ce5b60e"
    sha256 cellar: :any, catalina:      "efc96d2467b4ee2453af02be28115f64b191dcdf19351733866f76acd0685e60"
  end

  depends_on xcode: "12.0"
  uses_from_macos "ruby" => :build

  def install
    system "rake", "build"
    bin.install "cli/bin/sourcery"
    lib.install Dir["cli/lib/*.dylib"]
  end

  test do
    # Regular functionality requires a non-sandboxed environment, so we can only test version/help here.
    assert_match version.to_s, shell_output("#{bin}/sourcery --version").chomp
  end
end
