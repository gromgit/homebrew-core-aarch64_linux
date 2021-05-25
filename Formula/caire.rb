class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.3.0.tar.gz"
  sha256 "61e0d45fce7006b5fc01cbd1db8cdfc6ce36f62929fa993dc0c6e7eaf07ca430"
  license "MIT"
  head "https://github.com/esimov/caire.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "0090dc37161ce7aff26f2fe47f56908355440c59909381c7c2bc420d0a9a02f3"
    sha256 cellar: :any_skip_relocation, big_sur:       "8ab75ba3776f3325a6e534585a3f0caeca4b7b984337ada3adda768018361484"
    sha256 cellar: :any_skip_relocation, catalina:      "a330a5bbbc00f82e32950265d39ddb5499b6190f8eb02c500a18d46b5b795bff"
    sha256 cellar: :any_skip_relocation, mojave:        "5aa3249d567a0e668e2b0437942270a7834868293eceab2a33a1e6335ebdcf2d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "./cmd/caire"
  end

  test do
    system bin/"caire", "-in", test_fixtures("test.png"), "-out", testpath/"test_out.png",
           "-width=1", "-height=1", "-cc=data/facefinder", "-perc=1"
    assert_predicate testpath/"test_out.png", :exist?
  end
end
