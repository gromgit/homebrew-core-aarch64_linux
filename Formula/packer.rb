class Packer < Formula
  desc "Tool for creating identical machine images for multiple platforms"
  homepage "https://packer.io"
  url "https://github.com/hashicorp/packer.git",
      :tag      => "v1.5.4",
      :revision => "30aa6a0cb45e38638479a9d9c1889e9086b686c4"
  head "https://github.com/hashicorp/packer.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "92f840c0aa8c41bb864a604beb3891b33b240565fef2c5fa26c5ea1c05d916c8" => :catalina
    sha256 "f7872d2bdb8401611b9036c1f03fac33e9edcceed2469d45ef49cafa216145a6" => :mojave
    sha256 "ec718102d4d98ac9499167169bcbafb0cc356e3fdeb6eff018ae84fade86fee0" => :high_sierra
  end

  depends_on "coreutils" => :build
  depends_on "go" => :build

  def install
    (buildpath/"bin").mkpath
    if build.head?
      system "make", "bin"
    else
      system "make", "releasebin"
    end
    bin.install buildpath/"bin/packer"
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
