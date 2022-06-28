class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.15.tar.gz"
  sha256 "805fa0288162eb88ed390a1a8f6650d9f6aff3b3129831a882e9e93d7ad185f8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6e4403515b9013c815b128f58b0d36f095531a027f7f80d2b0443153a282c02f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6e4403515b9013c815b128f58b0d36f095531a027f7f80d2b0443153a282c02f"
    sha256 cellar: :any_skip_relocation, monterey:       "32349c0e9e3d94e4d4be09d690725a427e3fb1126443ffc4704f19f788d68b7e"
    sha256 cellar: :any_skip_relocation, big_sur:        "32349c0e9e3d94e4d4be09d690725a427e3fb1126443ffc4704f19f788d68b7e"
    sha256 cellar: :any_skip_relocation, catalina:       "32349c0e9e3d94e4d4be09d690725a427e3fb1126443ffc4704f19f788d68b7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0d3d527cb8a2d3f0e841759cfd2235ab8de7f267dfb1441a9759d048ff42400"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/rhysd/actionlint.version=#{version}"), "./cmd/actionlint"
    system "ronn", "man/actionlint.1.ronn"
    man1.install "man/actionlint.1"
  end

  test do
    (testpath/"action.yaml").write <<~EOS
      name: Test
      on: push
      jobs:
        test:
          steps:
            - run: actions/checkout@v2
    EOS

    assert_match "\"runs-on\" section is missing in job", shell_output(bin/"actionlint #{testpath}/action.yaml", 1)
  end
end
