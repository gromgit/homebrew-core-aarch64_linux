class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.11.2",
      revision: "e31f7806dc0073159cc12dce7605073259105a67"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4e888dba2b1f9fb36be8d69428882d6f5b388215868e740a698225042792ec18"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d153bf7a98a9e85d75adb6cf13c23f52dc5dda20ce33af45c5ca887994175aa0"
    sha256 cellar: :any_skip_relocation, monterey:       "3fb7ce299527c23cde64065537889d13bd22e5f5b47490a02b3fdebc62309412"
    sha256 cellar: :any_skip_relocation, big_sur:        "085c4714f00a14a63363146460383b7a0bcea5d9d181c3a9c55d43029f6048e1"
    sha256 cellar: :any_skip_relocation, catalina:       "0dcb74064bbfad6252fea087b8a271729ec21d608f44fb5c42c4aa0756e84d86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ed91cde4631ef8ef8c42905b0ee748390a0d5dcf392b9435044d07076e9d764"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_head}
      -X main.builtBy=homebrew
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    # Install shell completions
    generate_completions_from_executable(bin/"goreleaser", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/goreleaser -v 2>&1")
    assert_match "config created", shell_output("#{bin}/goreleaser init --config=.goreleaser.yml 2>&1")
    assert_predicate testpath/".goreleaser.yml", :exist?
  end
end
