class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.7.6.tar.gz"
  sha256 "2e414c4c7ae930f3d2851de39f31f159eb1b073401956a6856bd89d592664b50"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "master"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1136ce46d9b9f67f2a439f18eda1766c7cb0298828306e16e8fb49c5e089611b"
    sha256 cellar: :any_skip_relocation, big_sur:       "9eb86502d668325aee928bf9ff03b7170d51ba7671b2118c7056ea5897405e98"
    sha256 cellar: :any_skip_relocation, catalina:      "e239bc22814bbc1cbe7f2847ca01d106dc186f5c6eba7101d064299e5284b98a"
    sha256 cellar: :any_skip_relocation, mojave:        "24f234bdecae253fe90bb68403eb80b6163cc37e201a1c30d0dcbf4397a8607f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f45de798f739be21f1ddac4f73071ccd64f28ed0f08f531d05949664dec9196d"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")

    # Allow packer to find plugins in Homebrew prefix
    bin.env_script_all_files libexec/"bin", PACKER_PLUGIN_PATH: "$PACKER_PLUGIN_PATH:#{HOMEBREW_PREFIX/"bin"}"

    zsh_completion.install "contrib/zsh-completion/_packer"
  end

  test do
    minimal = testpath/"minimal.json"
    minimal.write <<~EOS
      {
        "builders": [{
          "type": "amazon-ebs",
          "region": "us-east-1",
          "source_ami": "ami-59a4a230",
          "instance_type": "m3.medium",
          "ssh_username": "ubuntu",
          "ami_name": "homebrew packer test  {{timestamp}}"
        }],
        "provisioners": [{
          "type": "shell",
          "inline": [
            "sleep 30",
            "sudo apt-get update"
          ]
        }]
      }
    EOS
    system "#{bin}/packer", "validate", "-syntax-only", minimal
  end
end
