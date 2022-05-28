class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer/archive/v1.8.1.tar.gz"
  sha256 "2a264119f7bdeeb82e79e0c9a02e4fa3d9bdf3e984c47e0c89ca2856eecb3b88"
  license "MPL-2.0"
  head "https://github.com/hashicorp/packer.git", branch: "main"

  livecheck do
    url "https://releases.hashicorp.com/packer/"
    regex(%r{href=.*?v?(\d+(?:\.\d+)+)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "544fe27d97d08f7a32e715f78c782b0a4a5942b58749d290e17e5fd78ed07f02"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f524c1e8a031dc418c448af522c2ec89cd9107ee33c2feb7efec9132a6e6997b"
    sha256 cellar: :any_skip_relocation, monterey:       "1ffc0eeda12912b79fc06d10f32fdb55244b306785df1081b3051878301d8161"
    sha256 cellar: :any_skip_relocation, big_sur:        "f8b0568aec99863f9ff72ba4ee78dbccfec6e0df837b4e76d7109f7a0abe3cca"
    sha256 cellar: :any_skip_relocation, catalina:       "b3076c00af351c6f93e7b5f8af91bf41218fbce6c2afc8c32537eb47fbdbd07a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "282225472a39e3837aea952f62b128fc2709452875759cb9a2ca2d1de45a123e"
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
