class PamReattach < Formula
  desc "PAM module for reattaching to the user's GUI (Aqua) session"
  homepage "https://github.com/fabianishere/pam_reattach"
  url "https://github.com/fabianishere/pam_reattach/archive/v1.2.tar.gz"
  sha256 "60133388c400a924ca05ee0e5e6f9cc74c9f619bf97e545afe96f35544b0d011"
  license "MIT"
  head "https://github.com/fabianishere/pam_reattach.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e9218600ff06c3bf61186e9314aff20aefe47be79b22be0e910fa4402c449c70"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "50c4f1b26c54e6c2a36c57809aa7bd8c5ad4180558f2e1ebeb26c0c5fd779865"
    sha256 cellar: :any_skip_relocation, monterey:       "8c8f2f53c07ce108244e8adbd50ad6964de6e8b7c2e7f4119ed002b97eeb141a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a543e13c02ddb50ec3f430368a90a3f3efbd41e86367b79976114766328812e9"
    sha256 cellar: :any_skip_relocation, catalina:       "e6d0534491e585348574cde394af4214660c8c0308ebdde9627944df40211847"
  end

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
