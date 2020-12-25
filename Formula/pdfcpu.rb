class Pdfcpu < Formula
  desc "PDF processor written in Go"
  homepage "https://pdfcpu.io"
  url "https://github.com/pdfcpu/pdfcpu/archive/v0.3.8.tar.gz"
  sha256 "7453c666570e8b93d9b71491f9b36192f80aafb43081ca9643cfed401341f465"
  license "Apache-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "567fd746fc74e9dae31703ff55a960e791c111763266f491700794c4c2f17936" => :big_sur
    sha256 "05baf4ad03a1ae4b6c74b622815736c7a1fabf917118966e31239f46d80b0f6b" => :catalina
    sha256 "fb609b65a100d0a3b043e5509ca68ea72de824ce30131b5fdfbe6a69f96f55b5" => :mojave
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
