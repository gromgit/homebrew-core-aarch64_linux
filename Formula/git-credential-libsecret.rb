class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.34.1.tar.xz"
  sha256 "3a0755dd1cfab71a24dd96df3498c29cd0acd13b04f3d08bf933e81286db802c"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_big_sur: "51c13772e5cfa3df13c23d63b3b899d3f0d2bc2ddad87d16d444fb56edc036d5"
    sha256 cellar: :any,                 monterey:      "555b0697b9e405745296ace58de78add665fc7134cb66b46c68bddbd95af1157"
    sha256 cellar: :any,                 big_sur:       "dcffce8ffe455fee1cbb3c9c7a44ca2dcc64bca6aaac58d22776710e8c16d597"
    sha256 cellar: :any,                 catalina:      "56e851519c6c1f4018ac7971652dd8ad383969f9b27990e1adf74a2581b9e8f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b8512f6163cef92d6f337f977137d3529585c350d0fdd73ce99bf230c11e3d6f"
  end

  depends_on "pkg-config" => :build
  depends_on "glib"
  depends_on "libsecret"

  def install
    cd "contrib/credential/libsecret" do
      system "make"
      bin.install "git-credential-libsecret"
    end
  end

  test do
    input = <<~EOS
      protocol=https
      username=Homebrew
      password=123
    EOS
    output = <<~EOS
      username=Homebrew
      password=123
    EOS
    assert_equal output, pipe_output("#{bin}/git-credential-libsecret get", input, 1)
  end
end
