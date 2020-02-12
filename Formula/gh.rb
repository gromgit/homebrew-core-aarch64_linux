class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.5.4.tar.gz"
  sha256 "eacf8dcc085e0a65a76bbc94b8501fd7c2b37e511dd2e24361c02e80e87ba642"

  bottle do
    cellar :any_skip_relocation
    sha256 "34898db0e30e06c51a80dcb899684190587ae4c256cc6a88a1ab8353e5cf41bb" => :catalina
    sha256 "683e778e64e26bd1a0107369fb7f4fc9811391451576ebec031c21f12b54787a" => :mojave
    sha256 "1fa70279798cf1519429d15a90fa539867a625a637422c5a7af236a725de63d8" => :high_sierra
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X github.com/cli/cli/command.Version=#{version}
      -X github.com/cli/cli/command.BuildDate=#{Date.today}
      -s -w
    ]
    system "go", "build", "-trimpath", "-ldflags", ldflags.join(" "), "-o", bin/name, "./cmd/gh"

    (bash_completion/"gh").write `#{bin}/gh completion -s bash`
    (fish_completion/"gh.fish").write `#{bin}/gh completion -s fish`
    (zsh_completion/"_gh").write `#{bin}/gh completion -s zsh`
  end

  test do
    assert_match "gh version #{version}", shell_output("#{bin}/gh --version")
    assert_match "Work with GitHub issues.", shell_output("#{bin}/gh issue 2>&1")
    assert_match "Work with GitHub pull requests.", shell_output("#{bin}/gh pr 2>&1")
  end
end
