class Caire < Formula
  desc "Content aware image resize tool"
  homepage "https://github.com/esimov/caire"
  url "https://github.com/esimov/caire/archive/v1.3.0.tar.gz"
  sha256 "61e0d45fce7006b5fc01cbd1db8cdfc6ce36f62929fa993dc0c6e7eaf07ca430"
  license "MIT"
  head "https://github.com/esimov/caire.git"

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
