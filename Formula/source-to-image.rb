class SourceToImage < Formula
  desc "Tool for building source and injecting into docker images"
  homepage "https://github.com/openshift/source-to-image"
  url "https://github.com/openshift/source-to-image.git",
      tag:      "v1.3.1",
      revision: "a5a771479f73be6be4207aadc730351e515aedfb"
  license "Apache-2.0"
  head "https://github.com/openshift/source-to-image.git", branch: "master"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/source-to-image"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "fc432a21c1df3eaaa0cf7be8add5328423f92968e96317e5798ffc4d5da0c000"
  end

  # Bump to 1.18 on the next release, if possible.
  depends_on "go@1.17" => :build

  def install
    system "hack/build-go.sh"
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch.to_s
    bin.install "_output/local/bin/#{OS.kernel_name.downcase}/#{arch}/s2i"
  end

  test do
    system "#{bin}/s2i", "create", "testimage", testpath
    assert_predicate testpath/"Dockerfile", :exist?, "s2i did not create the files."
  end
end
