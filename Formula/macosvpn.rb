class Macosvpn < Formula
  desc "Create Mac OS VPNs programmatically"
  homepage "https://github.com/halo/macosvpn"
  url "https://github.com/halo/macosvpn/archive/1.0.3.tar.gz"
  sha256 "1922ba78d40efa08b6f79ccb8d74b2f859ec39a5c37622a7d1ecbb3ba50cff6a"
  license "MIT"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fe46251025193a2b7ab448c8094cae06b1671b60ed176421726e791dd05b64b9" => :big_sur
    sha256 "e02bb2714e5ad70a64e47efdecf2fd37072ca23a9c0bb462131c0c4b52fc1743" => :arm64_big_sur
    sha256 "c08986d8e595ec51aa48a309197bdfbdb6daa2bf3b470352a7f931daf54f740e" => :catalina
    sha256 "e8e62ac32fd934867c66b405a6b9f91c25574a34451827f8cff259e0235482dc" => :mojave
  end

  depends_on xcode: ["11.1", :build]

  def install
    xcodebuild "SYMROOT=build"
    bin.install "build/Release/macosvpn"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/macosvpn version", 2)
  end
end
