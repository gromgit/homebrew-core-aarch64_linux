class Frugal < Formula
  desc "Cross language code generator for creating scalable microservices"
  homepage "https://github.com/Workiva/frugal"
  url "https://github.com/Workiva/frugal/archive/v3.13.1.tar.gz"
  sha256 "d71b48ba6834b62ae5f52b7f50cd768af5a483283c0deed043ff4c6dde3f2344"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "369884fc774bbae0c7c11ea6614017d5bad0876c7ac937f6308dbe6e91eb2589" => :big_sur
    sha256 "dc2e1ae92b14e90836aeb14f2dedbb6ca5a00f1732a254a37d0c1bb500b74438" => :catalina
    sha256 "f058455ad10668e0861daae8f5342eb5e91cc83480aeff795df487170ab9b8e0" => :mojave
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
