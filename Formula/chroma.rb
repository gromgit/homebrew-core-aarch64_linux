class Chroma < Formula
  desc "General purpose syntax highlighter in pure Go"
  homepage "https://github.com/alecthomas/chroma"
  url "https://github.com/alecthomas/chroma/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "5d6b9986a175ed8ca789e55e42bb4d0f6089b408824b0654b57c7fcb91c06c07"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e3ba2c4c3b74a9ee98bd158361d0e752d16bd011ba19f2a25abf1cc56653dcdf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f97e7225b02766b8bc0b9f3c66ac977604e639c2338b117714e4ecaa50bcaf07"
    sha256 cellar: :any_skip_relocation, monterey:       "7c2c71323df309b9482c9d428ef068d2d9d697d867033c19e0d54b034f0fb91a"
    sha256 cellar: :any_skip_relocation, big_sur:        "2e821c0ffddc1055ce01b66bd336973ac02dc365c046cbacee1d66e9bd6a9b5b"
    sha256 cellar: :any_skip_relocation, catalina:       "c7a42922bb80fbd947d6daf10fc5c7bc3f6d15be486f444afccc84d3c9d2f005"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1bd43f02c227901f95bc31b3cb5e22574da2785bb55988267c60d0aff3c50c62"
  end

  depends_on "go" => :build

  def install
    cd "cmd/chroma" do
      system "go", "build", *std_go_args(ldflags: "-s -w")
    end
  end

  test do
    json_output = JSON.parse(shell_output("#{bin}/chroma --json #{test_fixtures("test.diff")}"))
    assert_equal "GenericHeading", json_output[0]["type"]
  end
end
