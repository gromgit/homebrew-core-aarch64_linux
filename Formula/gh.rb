class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v1.2.1.tar.gz"
  sha256 "ae7f03426b9d9ebf40be3cdbd4ce8cec7aeeda8e51acd34d8d0aaf0b3c4ea550"
  license "MIT"

  livecheck do
    url "https://github.com/cli/cli/releases/latest"
    regex(%r{href=.*?/tag/v?(\d+(?:\.\d+)+)["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "e778e471372364f8902c7b313284072c72f8610cb5e163d0ca76a615850cb4aa" => :big_sur
    sha256 "11d663b3712fe2c0fb7b834a49da1bd872cc2f9da1efcee6d081e692bc255d8e" => :catalina
    sha256 "bbb71a404ce321c53b95bacdc08618d462fb247865c4cc12980d974b2d38ab0a" => :mojave
    sha256 "0b1e2a2959043d3e81b2e93f4079605ea75d1641d57c62c08358880826380ce7" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ENV["GH_VERSION"] = version.to_s
    ENV["GO_LDFLAGS"] = "-s -w"
    system "make", "bin/gh", "manpages"
    bin.install "bin/gh"
    man1.install Dir["share/man/man1/gh*.1"]
    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests", shell_output("#{bin}/gh pr 2>&1")
  end
end
