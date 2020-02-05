class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.2.tar.gz"
  sha256 "4258d6a86d48d18da89ac9f307e8b6c6c93d5de59403dfc563db256317a7f576"

  bottle do
    cellar :any_skip_relocation
    sha256 "415443f104d02baa622d899eeee490937dbde9dd6eb9ea7b439c27830c6213e2" => :catalina
    sha256 "e93767228f9a034e686e5687cfda91416139aa27eca3cd6fbc23773701c168bb" => :mojave
    sha256 "b4c5b54a3b826aad673529fae0535b76dcff89c24247d2053c929c2712e8964d" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", "-trimpath", "-o", bin/"pdfcpu", "-ldflags",
           "-X github.com/pdfcpu/pdfcpu/pkg/pdfcpu.VersionStr=#{version}", "./cmd/pdfcpu"
  end

  test do
    info_output = shell_output("#{bin}/pdfcpu info #{test_fixtures("test.pdf")}")
    assert_match "PDF version: 1.6", info_output
    assert_match "Page count: 1", info_output
    assert_match "Page size: 500.00 x 800.00 points", info_output
    assert_match "Encrypted: No", info_output
    assert_match "Permissions: Full access", info_output
    assert_match "validation ok", shell_output("#{bin}/pdfcpu validate #{test_fixtures("test.pdf")}")
  end
end
