class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.35.3.tar.xz"
  sha256 "15e9db4f9bf2ed9fff30cb62a00c5c7c0901015f5ab048cdb4e8b04ddee00fa2"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e9c5bd99616bfc38663719760da5697005c7ca04828550b2f7eeb51ef006c1ed"
    sha256 cellar: :any,                 arm64_big_sur:  "eddd734a32c48b5ff17060b4a100a9ef9f59a3557676f9e19827b99ecc0954c8"
    sha256 cellar: :any,                 monterey:       "11afeeddfa48cbbf711cba3d2caeab9c1b1e72326b6bae5e565ca5b342f7256a"
    sha256 cellar: :any,                 big_sur:        "65cf0bb56c8487973d867511b173a837907f6702de09ab816bd23368450d92f5"
    sha256 cellar: :any,                 catalina:       "9a6e58d4460ca6637fc3e180357d8d567633b6e5a81b4a66852e2b917ee7c972"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8e4786281c048995bb717ac8590b7162e7491b1b26d40f1132570e9f189bb117"
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
