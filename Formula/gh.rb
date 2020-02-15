class Gh < Formula
  desc "GitHub command-line tool"
  homepage "https://github.com/cli/cli"
  url "https://github.com/cli/cli/archive/v0.5.5.tar.gz"
  sha256 "7c2cfdafe765a598b70b3e6de839590e8fa30a89bedc85799a43bdbc6fd3277e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d659a44a3d0e44f95d5a7d1ec13124d3bc5ecb5097ff37bb92536e884ba1e0f" => :catalina
    sha256 "bfcfb9a05071948c20daf4f0a72256046c6727895c5a4996cc22c72e81c6dd36" => :mojave
    sha256 "c69cefd2a1a23b23ee84a02ad1c9844dc136cde83fb625440d3059e5e5cb368d" => :high_sierra
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
