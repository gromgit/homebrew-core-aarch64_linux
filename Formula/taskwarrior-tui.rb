class TaskwarriorTui < Formula
  desc "Terminal user interface for taskwarrior"
  homepage "https://github.com/kdheepak/taskwarrior-tui"
  url "https://github.com/kdheepak/taskwarrior-tui/archive/v0.9.1.tar.gz"
  sha256 "f4d3f3edd2dc0931dc8a8b46c368f86b65c875ba3530479bad4e0e81e5bea093"
  license "MIT"
  head "https://github.com/kdheepak/taskwarrior-tui.git"

  livecheck do
    url "https://github.com/kdheepak/taskwarrior-tui/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "f4e90c97e487d9f4e2ff4eb348b992d91ab5dd596b0c4f0a8694d9fb6300dda9" => :catalina
    sha256 "e9220b3c5e471c626a8863d7c1e9847c181953fe27ea1f6749f6fec6c1fd9d80" => :mojave
    sha256 "dd4678c8654e6c26b2ebb813e73233446d69e07b97c150fd928f7ad43e96bbc1" => :high_sierra
  end

  depends_on "rust" => :build
  depends_on "task"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/taskwarrior-tui --version")
    assert_match "The argument '--config <FILE>' requires a value but none was supplied",
      shell_output("#{bin}/taskwarrior-tui --config 2>&1", 1)
  end
end
