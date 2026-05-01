import 'package:flutter/material.dart';


class SignUpPage extends StatelessWidget {
  const SignUpPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Padding(padding: EdgeInsets.all(16),
          child: Column(
            children: [
              SizedBox(height: 20,),
              _buildHeader(),
              SizedBox(height: 30,),
              _buildLoginCard(),
            ],
          ),),
      ),
    );
  }





  Widget _buildHeader() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircleAvatar(
              radius: 18,
              backgroundColor: Colors.blueGrey,
              child: Icon(Icons.location_on, color: Colors.black),
            ),
            const SizedBox(width: 8),
            const Text(
              "TrustHire",
              style: TextStyle(
                fontSize: 26,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        const Text(
          "Connecting Excellence With Opportunity",
          style: TextStyle(color: Colors.grey, fontSize: 16),
        ),
      ],
    );
  }




  Widget _buildLoginCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey.shade300),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 10,
          )
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              "Create New Account",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 20),
          _buildTabs(),
          const SizedBox(height: 20),
          const Text(
            "Enter Phone Number",
            style: TextStyle(fontSize: 16),
          ),
          const SizedBox(height: 10),
          _buildTextField(),
          const SizedBox(height: 20),
          _buildButton(),
          const SizedBox(height: 15),
          _buildLinks(),
          const SizedBox(height: 20),
          const Center(
            child: Text(
              "For any info please call +8801733850274",
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTabs() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        children: [
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(30),
              ),
              child: const Center(child: Text("Login")),
            ),
          ),
          Expanded(
            child: Container(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: const Center(
                child: Text(
                  "Create Account",
                  style: TextStyle(color: Colors.grey),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTextField() {
    return TextField(
      decoration: InputDecoration(
        hintText: "Type Here",
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: Colors.black),
        ),
      ),
    );
  }
  Widget _buildButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blueGrey,
          padding: const EdgeInsets.symmetric(vertical: 14),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
        ),
        onPressed: () {},
        child: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "CONTINUE",
              style: TextStyle(color: Colors.black),
            ),
            SizedBox(width: 8),
            Icon(Icons.arrow_forward, color: Colors.black),
          ],
        ),
      ),
    );
  }

  Widget _buildLinks() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Text(
          "Create Account",
          style: TextStyle(decoration: TextDecoration.underline),
        ),
        SizedBox(width: 10),
        Text("•"),
        SizedBox(width: 10),
        Text(
          "Forgot Password?",
          style: TextStyle(decoration: TextDecoration.underline),
        ),
      ],
    );
  }
}
