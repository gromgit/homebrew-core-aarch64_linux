class Wskdeploy < Formula
  desc "Apache OpenWhisk project deployment utility"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-wskdeploy/archive/1.2.0.tar.gz"
  sha256 "bffe6f6ef2167189fc38893943a391aaf7327e9e6b8d27be1cc1c26535c06e86"
  license "Apache-2.0"

  bottle do
    root_url "https://github.com/gromgit/homebrew-core-aarch64_linux/releases/download/wskdeploy"
    sha256 cellar: :any_skip_relocation, aarch64_linux: "9c681852e212cd57f0dd7979fc4712ea38de0c7720d462c64d2f70ac3be7d1e1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args, "-ldflags", "-X main.Version=#{version}"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wskdeploy version")

    (testpath/"manifest.yaml").write <<~EOS
      packages:
        hello_world_package:
          version: 1.0
          license: Apache-2.0
    EOS

    system bin/"wskdeploy", "-v",
                            "--apihost", "openwhisk.ng.bluemix.net",
                            "--preview",
                            "-m", testpath/"manifest.yaml",
                            "-u", "abcd"
  end
end
