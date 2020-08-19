class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.9.9.tar.gz"
  sha256 "e7ddafb70f8413fb62f4d4760437bdc881c4da4a903e8c4fa22c7298ca0cc98e"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "8dbbf908ed515daabb13147b3dbdea06c02a49afb4a04e927b5d61aa262e75bc" => :catalina
    sha256 "83c2ca4664abf04225569af7d32b2744b4952e0816ed725bb054b2792b532552" => :mojave
    sha256 "6a3719a27f0e050bd9c2f251ccf5c3a7a9090303f3ae4f417020b2e1e2061f3a" => :high_sierra
  end

  depends_on "glide" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/Workiva/frugal").install buildpath.children
    cd "src/github.com/Workiva/frugal" do
      system "glide", "install"
      system "go", "build", "-o", bin/"frugal"
      prefix.install_metafiles
    end
  end

  test do
    (testpath/"test.frugal").write("typedef double Test")
    system "#{bin}/frugal", "--gen", "go", "test.frugal"
    assert_match "type Test float64", (testpath/"gen-go/test/f_types.go").read
  end
end
