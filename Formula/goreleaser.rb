class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.142.0",
      revision: "e014ad0ae88480406206c7758f3607168b45ced9"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "7ad9ac6b848fe032f38c8a92a781853bf5cadf1e7fda17d82a41f3a2216c7d05" => :catalina
    sha256 "de00d7da6af68ce427fb44bbfa1f3d78819df32ac7a19df808abc319982646fc" => :mojave
    sha256 "ccff9bcc3cf0f2a49fde956beaac84c57d9d4045de6a59c7a7168587f57a5068" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-ldflags",
             "-s -w -X main.version=#{version} -X main.commit=#{stable.specs[:revision]} -X main.builtBy=homebrew",
             *std_go_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
