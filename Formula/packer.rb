class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      tag:      "v1.6.5",
      revision: "945908fd74adc3d63687b96caaf55749b44b5625"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3a7145af46f765f9c29f3d9019f174f34ecdf0f38ff7c343cbe247721e7c78cd" => :big_sur
    sha256 "b112017e8bf0c69756c17849b1a5b17a4820f705d4a88cfeaa584e95e7a6a7de" => :catalina
    sha256 "4be1290b8d4e4e3fdf34b75535b4136e24355a8a165ccdf08d5fa58e801ac1b8" => :mojave
    sha256 "1205b8daec00af365f36d44b6a9343cb9ba0a2e8e5534520199f0f3f656c9dbc" => :high_sierra
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args
    zsh_completion.install "contrib/zsh-completion/_packer"
    prefix.install_metafiles
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
