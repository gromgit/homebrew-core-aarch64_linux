class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.15.5.tar.gz"
  sha256 "db42142d4f6da2dd3f947bba5a27aadc6497f3aa4aac7a619fd3b9758d2931c9"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "88c6383617e9287642d1933edea656722d2a3e9995bd40715ef31cdd22079bce"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "88c6383617e9287642d1933edea656722d2a3e9995bd40715ef31cdd22079bce"
    sha256 cellar: :any_skip_relocation, monterey:       "78f37a2541cb9dc039e1db8fba212f762bd22f740e31c203bcfcfa0de1f3f5d0"
    sha256 cellar: :any_skip_relocation, big_sur:        "78f37a2541cb9dc039e1db8fba212f762bd22f740e31c203bcfcfa0de1f3f5d0"
    sha256 cellar: :any_skip_relocation, catalina:       "78f37a2541cb9dc039e1db8fba212f762bd22f740e31c203bcfcfa0de1f3f5d0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4f44af6cda6b433d1932e0c80cc30bf015b6451776489eba2acba5711de46003"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
