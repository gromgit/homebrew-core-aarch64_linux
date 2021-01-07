class GoBindata < Formula
  desc "Small utility that generates Go code from any file"
  homepage "https://github.com/kevinburke/go-bindata"
  url "https://github.com/kevinburke/go-bindata/archive/v3.22.0.tar.gz"
  sha256 "1ad4c1e8db221aadd53c69d4cb4e3ebfeae203ecc61f40dfd4679c2b0d23a932"
  license "BSD-2-Clause"
  revision 1

  bottle do
    cellar :any_skip_relocation
    sha256 "2fb3ca58e13165e105d9f58e446f22a093c62fb19d48177b88baeedf9e6311e7" => :big_sur
    sha256 "d9f81a83f5ad2ec18e2adaba9a4b6b2c04de17ca1d75eb47e5732e4175ec04ad" => :catalina
    sha256 "6a40fbbf67f008bc90da4c5c7a303485a2271291c63f23b09c60f4fa1a8b9e38" => :mojave
    sha256 "f722a47ec51be8a6e140a37a097afd171f4669e1e8dfd09411dc124f89efbf06" => :high_sierra
  end

  depends_on "go"

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"
    (buildpath/"src/github.com/kevinburke").mkpath
    ln_s buildpath, buildpath/"src/github.com/kevinburke/go-bindata"
    system "go", "build", "-o", bin/"go-bindata", "./go-bindata"
  end

  test do
    (testpath/"data").write "hello world"
    system bin/"go-bindata", "-o", "data.go", "data"
    assert_predicate testpath/"data.go", :exist?
    assert_match '\xff\xff\x85\x11\x4a', (testpath/"data.go").read
  end
end
