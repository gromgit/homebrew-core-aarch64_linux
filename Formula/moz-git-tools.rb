class MozGitTools < Formula
  desc "Tools for working with Git at Mozilla"
  homepage "https://github.com/mozilla/moz-git-tools"
  url "https://github.com/mozilla/moz-git-tools.git",
      tag:      "v0.1",
      revision: "cfe890e6f81745c8b093b20a3dc22d28f9fc0032"
  license "GPL-2.0"
  head "https://github.com/mozilla/moz-git-tools.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/moz-git-tools"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "eaed1078588971b4369b52d732ff28c7aed48684288b8452c14a6741db25f9dc"
  end

  def install
    # Install all the executables, except git-root since that conflicts with git-extras
    bin_array = Dir.glob("git*").push("hg-patch-to-git-patch")
    bin_array.delete("git-root")
    bin_array.delete("git-bz-moz") # a directory, not an executable
    bin_array.each { |e| bin.install e }
  end

  def caveats
    <<~EOS
      git-root was not installed because it conflicts with the version provided by git-extras.
    EOS
  end

  test do
    # create a Git repo and check its branchname
    (testpath/".gitconfig").write <<~EOS
      [user]
        name = Real Person
        email = notacat@hotmail.cat
    EOS
    system "git", "init"
    (testpath/"myfile").write("my file")
    system "git", "add", "myfile"
    system "git", "commit", "-m", "test"
    assert_match "master", shell_output("#{bin}/git-branchname")
  end
end
