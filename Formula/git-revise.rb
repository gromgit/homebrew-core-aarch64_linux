class GitRevise < Formula
  include Language::Python::Virtualenv

  desc "Rebase alternative for easy & efficient in-memory rebases and fixups"
  homepage "https://github.com/mystor/git-revise"
  url "https://files.pythonhosted.org/packages/8e/80/97eae3a7d93f8c17127ac5722ffb5a0f3b3bfd18525569865d2bfb5d27a1/git-revise-0.6.0.tar.gz"
  sha256 "21e89eba6602e8bea38b34ac6ec747acba2aee876f2e73ca0472476109e82bf4"
  license "MIT"
  revision 1
  head "https://github.com/mystor/git-revise.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "e259f71bef41a4a5b956fed4f7d619ceffdce443fbb8d06199239681133b196f" => :big_sur
    sha256 "b94663b14f3509958993f9c18fca3f4b2ecbf16901f3f7c61236e52bd180cfac" => :catalina
    sha256 "154cdb0cfa30aa40a4ca6498fbe7c8516c5153a3f2e181cf92d8f8894716b572" => :mojave
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
    man1.install "git-revise.1"
  end

  test do
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = J. Random Tester
        email = test@example.com
    EOS
    system "git", "init"
    (testpath/"test").write "foo"
    system "git", "add", "test"
    system "git", "commit", "--message", "a bad message"
    system "git", "revise", "--message", "a good message", "HEAD"
    assert_match "a good message", shell_output("git log --format=%B -n 1 HEAD")
  end
end
