class CfnFlip < Formula
  include Language::Python::Virtualenv

  desc "Convert AWS CloudFormation templates between JSON and YAML formats"
  homepage "https://github.com/awslabs/aws-cfn-template-flip"
  url "https://files.pythonhosted.org/packages/76/5a/314a934b75f2f52d1845e4344b9bbdacdd76d82784b678ec27c2ed57fd2c/cfn_flip-1.2.3.tar.gz"
  sha256 "2bed32a1f4dca26dc64178d52511fd4ef778b5ccbcf32559cac884ace75bde6a"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fa9e0a1f4ef0f98dff5a789bfca9bcc07dbc42b8abd36f29f52152f9908cc5a0"
    sha256 cellar: :any_skip_relocation, big_sur:       "a91993826fa88ef0dce786d49b3ad6ec66870d8589e77386c3e7ea89fea2a10e"
    sha256 cellar: :any_skip_relocation, catalina:      "a91993826fa88ef0dce786d49b3ad6ec66870d8589e77386c3e7ea89fea2a10e"
    sha256 cellar: :any_skip_relocation, mojave:        "a91993826fa88ef0dce786d49b3ad6ec66870d8589e77386c3e7ea89fea2a10e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "06a7855948400b72f52fd405d4f12a0736fc9060890e0c3549e71ac0895e0291"
  end

  depends_on "python@3.10"

  resource "click" do
    url "https://files.pythonhosted.org/packages/27/6f/be940c8b1f1d69daceeb0032fee6c34d7bd70e3e649ccac0951500b4720e/click-7.1.2.tar.gz"
    sha256 "d2b5255c7c6349bc1bd1e59e08cd12acbbd63ce649f2588755783aa94dfb6b1a"
  end

  resource "PyYAML" do
    url "https://files.pythonhosted.org/packages/64/c2/b80047c7ac2478f9501676c988a5411ed5572f35d1beff9cae07d321512c/PyYAML-5.3.1.tar.gz"
    sha256 "b8eac752c5e14d3eca0e6dd9199cd627518cb5ec06add0de9d32baeee6fe645d"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.json").write <<~EOS
      {
        "Resources": {
          "Bucket": {
            "Type": "AWS::S3::Bucket",
            "Properties": {
              "BucketName": {
                "Ref": "AWS::StackName"
              }
            }
          }
        }
      }
    EOS

    expected = <<~EOS
      Resources:
        Bucket:
          Type: AWS::S3::Bucket
          Properties:
            BucketName: !Ref 'AWS::StackName'
    EOS

    assert_match expected, shell_output("#{bin}/cfn-flip test.json")
  end
end
