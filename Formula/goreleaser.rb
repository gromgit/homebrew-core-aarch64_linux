class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v0.144.0",
      revision: "4471154461a6078893008e7978db9b5c39a1835d"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "22d3e54ff20496366653414f903856b3c920c9ff11e41d7d7cbad89b11bdd66e" => :catalina
    sha256 "0b7b99477faf0e1c8044d0386c92517f95db3f65d363f1e3933059513aa335cb" => :mojave
    sha256 "73d9a21b641a24ddd1ca3a081dfea156bf8d72ec6d837a995397cc87484e8dbe" => :high_sierra
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
