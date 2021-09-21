class Actionlint < Formula
  desc "Static checker for GitHub Actions workflow files"
  homepage "https://rhysd.github.io/actionlint/"
  url "https://github.com/rhysd/actionlint/archive/v1.6.4.tar.gz"
  sha256 "6b825c1348670bb1c0be8b1db858bfc88106b6e8daf5bb6a59d3fb30780a26fa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "9c8c55e768ef859bea64e68954ab6b110980275a9ac881a49286c39f683c5c07"
    sha256 cellar: :any_skip_relocation, big_sur:       "ffb219f8912bb976513c29f4e818d315c5fc42b2c6baecee99e68d0b5182485c"
    sha256 cellar: :any_skip_relocation, catalina:      "ffb219f8912bb976513c29f4e818d315c5fc42b2c6baecee99e68d0b5182485c"
    sha256 cellar: :any_skip_relocation, mojave:        "ffb219f8912bb976513c29f4e818d315c5fc42b2c6baecee99e68d0b5182485c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b0288444c50cb8efb826c90430a11c16141dd215f876bef62ba9917b5bc2ad13"
  end

  depends_on "go" => :build
  depends_on "ronn" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/actionlint"
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
