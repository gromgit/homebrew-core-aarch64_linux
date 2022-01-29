class GitCredentialLibsecret < Formula
  desc "Git helper for accessing credentials via libsecret"
  homepage "https://git-scm.com"
  url "https://mirrors.edge.kernel.org/pub/software/scm/git/git-2.35.1.tar.xz"
  sha256 "d768528e6443f65a203036266f1ca50f9d127ba89751e32ead37117ed9191080"
  license "GPL-2.0-or-later"
  head "https://github.com/git/git.git", branch: "master"

  livecheck do
    formula "git"
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "67b99a0bef773231492d03921808e6a40dd5cee09fffba3c4f7a5572fd7f2649"
    sha256 cellar: :any,                 arm64_big_sur:  "d48080738a3f5b046606411471a60eb8e4e83c2fe8c1f48d67b68a9400209fbb"
    sha256 cellar: :any,                 monterey:       "299cde0b6347e18e71ae5a3b878d83227590842e72e5debeef3706cf1a9e1d8c"
    sha256 cellar: :any,                 big_sur:        "137adf976b5afadb81c78bcdc7d702e1f48d5d15033904092d736e1fef777e8f"
    sha256 cellar: :any,                 catalina:       "d2d82f0f0f8199560d666c708994ba7786e67be9594524807a72cfa6a052417e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e67d78e353ed25e49bac11c640742b9d999e4972a044054689d6d28a160abe4"
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
