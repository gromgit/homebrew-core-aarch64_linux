class Stencil < Formula
  desc "Smart templating engine for service development"
  homepage "https://engineering.outreach.io/stencil/"
  url "https://github.com/getoutreach/stencil/archive/refs/tags/v1.20.1.tar.gz"
  sha256 "636de5ca44c854dd5c587b49150d194fb95c272883c68e52528f8b02a88bc928"
  license "Apache-2.0"
  head "https://github.com/getoutreach/stencil.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "96c2e049cad3450bc037ef59d46c4cd23ea7885e77e0eb85ed985e58f0d9d326"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bf7eb079e35b82900f6ec60af88dc5e4cb428a40bd3698a82b9d9b2677f567ec"
    sha256 cellar: :any_skip_relocation, monterey:       "995f72e37dd31df56147918e1b1aa350016f7a67faf425eae8e4b8a345f1ae8d"
    sha256 cellar: :any_skip_relocation, big_sur:        "43bca78884e4100e7b27aac28c9b262f838a556e554e5e2bd2f6c261a4c91f83"
    sha256 cellar: :any_skip_relocation, catalina:       "6f2032d5735276dd36bdec2e8aa3707ab05ccdfa1bba090bfd4d687983ea295a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f5ae7e18559da5ef020ae5c798e66984c72913e69e2630c37c774a268792be3"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w -X github.com/getoutreach/gobox/pkg/app.Version=v#{version} -X github.com/getoutreach/gobox/pkg/updater/Disabled=true"),
      "./cmd/stencil"
  end

  test do
    (testpath/"service.yaml").write "name: test"
    system bin/"stencil"
    assert_predicate testpath/"stencil.lock", :exist?
  end
end
