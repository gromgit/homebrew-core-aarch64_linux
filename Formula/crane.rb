class Crane < Formula
  desc "Tool for interacting with remote images and registries"
  homepage "https://github.com/google/go-containerregistry"
  url "https://github.com/google/go-containerregistry/archive/v0.11.0.tar.gz"
  sha256 "e2eac75200a38f9fecdd8a6b80a839a50898e3539e5625c2150f6d5d31317ade"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/crane"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9ae5645ee99c3bd8de611295aa3356cd32219878847ecd964138ac28455d8fe8"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/google/go-containerregistry/cmd/crane/cmd.Version=#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/crane"
  end

  test do
    json_output = shell_output("#{bin}/crane manifest gcr.io/go-containerregistry/crane")
    manifest = JSON.parse(json_output)
    assert_equal manifest["schemaVersion"], 2
  end
end
