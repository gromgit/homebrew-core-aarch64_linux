class Mage < Formula
  desc "Make/rake-like build tool using Go"
  homepage "https://magefile.org"
  url "https://github.com/magefile/mage.git",
      tag:      "v1.11.0",
      revision: "07afc7d24f4d6d6442305d49552f04fbda5ccb3e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "4069b791ba2512c595479f3c58a69503f31eff5ff4be94b710cebcba6555f4ca" => :big_sur
    sha256 "b4df8a2cf66691b661c0885023344f53524fade4b5f53a26e21bbfe9b2a1a326" => :arm64_big_sur
    sha256 "9cd3440367dc75056bc5ce8ecc8e7d5242cfddedd75aa3dae45c5297938e8003" => :catalina
    sha256 "8b5b1c1bd1226011028ec3bdc770557e4e14767d3d72468211e55e7101c51343" => :mojave
  end

  depends_on "go"

  def install
    commit = Utils.safe_popen_read("git", "rev-parse", "--short", "HEAD").chomp

    ldflags = %W[
      -s -w
      -X github.com/magefile/mage/mage.timestamp=#{Date.today}
      -X github.com/magefile/mage/mage.commitHash=#{commit}
      -X github.com/magefile/mage/mage.gitTag=#{version}
    ]
    system "go", "build", *std_go_args, "-ldflags", ldflags.join(" ")
  end

  test do
    assert_match "magefile.go created", shell_output("#{bin}/mage -init 2>&1")
    assert_predicate testpath/"magefile.go", :exist?
  end
end
