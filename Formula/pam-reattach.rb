class PamReattach < Formula
  desc "PAM module for reattaching to the user's GUI (Aqua) session"
  homepage "https://github.com/fabianishere/pam_reattach"
  url "https://github.com/fabianishere/pam_reattach/archive/refs/tags/v1.3.tar.gz"
  sha256 "b1b735fa7832350a23457f7d36feb6ec939e5e1de987b456b6c28f5738216570"
  license "MIT"
  head "https://github.com/fabianishere/pam_reattach.git", branch: "master"

  depends_on "cmake" => :build
  depends_on :macos

  def install
    system "cmake", ".", *std_cmake_args, "-DENABLE_CLI=ON"
    system "make", "install"
  end

  test do
    assert_match("Darwin", shell_output("#{bin}/reattach-to-session-namespace uname"))
  end
end
