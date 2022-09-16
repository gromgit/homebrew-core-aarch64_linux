class Goreleaser < Formula
  desc "Deliver Go binaries as fast and easily as possible"
  homepage "https://goreleaser.com/"
  url "https://github.com/goreleaser/goreleaser.git",
      tag:      "v1.11.3",
      revision: "0ea3e0f57289822085e5c0b554e2b430a40b832c"
  license "MIT"
  head "https://github.com/goreleaser/goreleaser.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31447cbd13b79da3856687a6a42c880ee27b6aaebeae75ea1ca04271b478b002"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "496a9b1911e7dde77e305a4f2008df823af6613069da6d5b525c4013e20be7d7"
    sha256 cellar: :any_skip_relocation, monterey:       "4d95bb266359892f3cc800097e0e2e6ca46e5e822ccf89511b96114121db3d14"
    sha256 cellar: :any_skip_relocation, big_sur:        "550239e4ca94f10529b31144996c49923c3699fa5c5a8a767cc9cb0c22344a60"
    sha256 cellar: :any_skip_relocation, catalina:       "8123860db93cbeffeba7d87f5ca827d1439f5d7f48a37b232422840ea6ac3f3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eeb928c0c80f95cdef99ab528cdeb57fcc81fc3af0d583c9558edd5f610737cd"
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
