AI Generated Open-Source Silicon Design Challenge
=================================================

AI RISCV Timer
--------------------

Table of Contents
-----------------

-  `About <#about>`__
-  `Step 1. Generation of the Verilog Code using AI Generated
   Tool <#step-1-generation-of-the-verilog-code-using-ai-generated-tool>`__

   -  `Using ChatGPT <#using-chatgpt>`__

      -  `1. Question Asked. generate a timer verilog code
         type <#1-question-asked-please-create-an-innovative-counter--of-completely-new-type>`__)
      -  `2. Question Asked. Clock is round 80MHz
         counter <#2-question-asked-more-complex-probablistic-counter>`__

   -  `Using Bard <#using-bard>`__

-  `Step 2. Cloning the Caravel
   Repo: <#step-2-cloning-the-caravel-repo->`__
-  `Step 3. Embedding the Verilog file to the
   User_Project_Wrapper <#step-3-embedding-the-verilog-file-to-the-user-project-wrapper>`__
-  `Step 4. Changes made to the
   config.json <#step-4-changes-made-to-the-configjson>`__
-  `Step 5. Run make openlane <#step-5-run-make-openlane>`__
-  `Step 6. Debugging with ChatGPT <#step-6-debugging-with-chatgpt>`__
-  `Step 7. OpenLane stuck at Detailed
   Route <#step-7-openlane-stuck-at-detailed-route>`__
-  `Step 8. Setting up in the cloud <#step-8-setting-up-in-the-cloud>`__
-  `Step 9. Flow Successful <#step-9-flow-successful>`__
-  `Step 10. Compressing the files <#step-10-compressing-the-files>`__
-  `Step 11. Uploaded the files on
   Github <#step-11-uploaded-the-files-on-github>`__
-  `Step 12. MPW-Precheck Submitted to
   Caravel <#step-12-mpw-precheck-submitted-to-caravel>`__
-  `Step 13. Tapeout Submitted to
   MPW-PreCheck <#step-13-tapeout-submitted-to-mpw-precheck>`__
-  `Step 14. Final Submission <#step-14-final-submission>`__
-  `Step 15. Comments made by ChatGPT on the
   repository <#step-15-comments-made-by-chatgpt-on-the-repository>`__
-  `THANK YOU! <#thank-you->`__

-  `Acknowledgement <#acknowledgement>`__
-  `Contributor <#contributor>`__
-  `References <#references>`__
-  `Forked from Caravel User
   Project <#forked-from-caravel-user-project>`__

   -  `Please fill in your project documentation in this README.md
      file <#please-fill-in-your-project-documentation-in-this-readmemd-file>`__

Table of contents generated with markdown-toc

About
-----

The detaisl of the AI Generated Open-Source Silicon Design Challenge can
be found here: https://efabless.com/ai-generated-design-contest

.. _step-1-generation-of-the-verilog-code-using-ai-generated-tool:

Step 1. Generation of the Verilog Code using AI Generated Tool
--------------------------------------------------------------

Using `ChatGPT <https://chat.openai.com/>`__:
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

I started off with asking ChatGPT to design various complicated and
innovative counter. It gave a Fractional Counter, a Adaptive Counting
Window Counter, a Self-Modifying Counter, a Bloom Filter Counter and
various other counters. Complete conversation can be found here:
https://chat.openai.com/share/87d72c4a-db14-4f90-97f6-ba1bad512cba. Here
are a few illustrations:

.. _1-question-asked-please-create-an-innovative-counter-of-completely-new-type:

1. Question Asked. Please create an innovative counter of completely new type
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Answer: |image|

--------------

.. _2-question-asked-more-complex-probablistic-counter:

2. Question Asked. more complex probablistic counter
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Answer: |image1|

--------------

.. _3-explanation-given-by-chatgpt:

3. Explanation given by ChatGPT
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/dfda0c0d-975b-4288-8537-35225cb1f745
   :alt: image

--------------

.. _4-question-asked-please-explain-the-above-counter-further-and-how-it-is-helpful:

4. Question Asked. Please explain the above counter further and how it is helpful?
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Answer: |image2|\  |image3|\  |image4|\ 

--------------

Using `Bard <https://bard.google.com/>`__
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

.. image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/6b7febac-07af-44b0-b410-27b5cfb749c9
   :alt: image

**However, based on the above answers, we finalized building up a Bloom
Filter Counter over the results given by ChatGPT!**

.. _step-2-cloning-the-caravel-repo:

Step 2. Cloning the Caravel Repo:
---------------------------------

Forking the `Caravel User Project
Repo <https://github.com/efabless/caravel_user_project>`__ and cloning
the copy.
``git clone https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc``\ 
Some points on Caravel by ChatGPT: |image5|

.. _step-3-embedding-the-verilog-file-to-the-user_project_wrapper:

Step 3. Embedding the Verilog file to the User_Project_Wrapper
--------------------------------------------------------------

For simplicity, the above `Bloom Counter Generated by
ChatGPT <https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/blob/main/verilog/rtl/dvsdfossbfc.v>`__
was Embedded in User_Project_Wrapper. Here is the code snippet:

::

   assign io_oeb[15:0]=16'b1111_1111_1111_1111;
   assign io_oeb[`MPRJ_IO_PADS-1:16]=0;
   assign io_out=1;
   assign la_data_out=1;
   assign wbs_dat_o=1;
   assign user_irq=1;
   reg [15:0] counter;
     reg [15:0] bloomFilter;
   always @(posedge user_clock2 or posedge io_in[0]) begin
       if (io_in[0]) begin
         counter <= 16'b0000_0000_0000_0000;
         bloomFilter <= 16'b0000_0000_0000_0000;
       end else if (io_in[9]) begin
         if (bloomFilter[io_in[8:1]]) begin
           // Bloom filter indicates that the input data is likely already counted
           counter <= counter;
         end else begin
           // Bloom filter indicates that the input data is likely not counted
           counter <= counter + 1;
           bloomFilter[io_in[8:1]] <= 1;
         end
       end
     end
     assign io_out[31:16]=counter;

.. raw:: html

   </br>
   The modified code is available [HERE](https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/blob/main/verilog/rtl/user_project_wrapper.v).

.. _step-4-changes-made-to-the-configjson:

Step 4. Changes made to the config.json
---------------------------------------

There were various errors as depicted in the actions page
`HERE <https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/actions>`__
during the flow. The new updated final json file can be found
`HERE <https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/blob/main/openlane/user_project_wrapper/config.json>`__

.. _step-5-run-make-openlane:

Step 5. Run make openlane
-------------------------

Executing the following commands to run: ``cd caravel_dvsdfossbfc``\ 
``make openlane``.

There were various issues which were debugged stepwise.

Some of them are present
`HERE <https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/blob/main/openlane/user_project_wrapper/config.json>`__.

Also, the `OpenLane
issues <https://github.com/The-OpenROAD-Project/OpenLane/issues>`__ page
helped.,/br>

.. _step-6-debugging-with-chatgpt:

Step 6. Debugging with ChatGPT
------------------------------

Here are some debugging of TCL scripts using the ChatGPT.

.. image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/e3b5214d-d4ff-45e1-95d0-39aa7268df33
   :alt: image

--------------

ChatGPT trying to correct the scripts: |image6|

.. _step-7-openlane-stuck-at-detailed-route:

Step 7. OpenLane stuck at Detailed Route
----------------------------------------

The flow stuck at the Detailed Route due to huge consumpsion of
RAM(>6GB).

The Repo was shifted to a Remote Desktop cloud provided by eFabless and
it worked.

.. _step-8-setting-up-in-the-cloud:

Step 8. Setting up in the cloud
-------------------------------

The following steps help to set up and run OpenLane again:
https://github.com/efabless/caravel_user_project/blob/main/docs/source/index.rst#section-quickstart

.. _step-9-flow-successful:

Step 9. Flow Successful
-----------------------

After around 2 hours the flow was successful. |image7|

.. _step-10-compressing-the-files:

Step 10. Compressing the files
------------------------------

The files greater than 100MB were compressed using the ``make compress``
command.

.. _step-11-uploaded-the-files-on-github:

Step 11. Uploaded the files on Github
-------------------------------------

The files were pushed using the ``git add`` and ``git push`` commands
through the SSH.

.. _step-12-mpw-precheck-submitted-to-caravel:

Step 12. MPW-Precheck Submitted to Caravel
------------------------------------------

.. _step-13-tapeout-submitted-to-mpw-precheck:

Step 13. Tapeout Submitted to MPW-PreCheck
------------------------------------------

.. _step-14-final-submission:

Step 14. Final Submission
-------------------------

.. _step-15-comments-made-by-chatgpt-on-the-repository:

Step 15. Comments made by ChatGPT on the repository
---------------------------------------------------

.. image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/ce7da985-b47c-434c-8c12-c8322a37f13e
   :alt: image

THANK YOU!
----------

Acknowledgement
===============

1. `eFabless Team <https://platform.efabless.com/>`__:For the help in
   helping me fix numerous errors during the flow and providing the
   Remote Desktop Cloud
2. `GOOGLE SKYWATER Team <https://github.com/google/skywater-pdk>`__:
   For providing such a platform
3. `VSD Team <https://www.vlsisystemdesign.com/ip/>`__: For motivation
   and quick debug
4. `OpenROAD Team <https://github.com/The-OpenROAD-Project/OpenLane>`__:
   For minor quick debug)
5. `FOSSEE Team <https://esim.fossee.in/>`__: For providing motivation

Contributor
===========

**Sumanto Kar**\  Project Staff and M.Tech Student Indian Institute of
technology, Bombay **Contact:**\ jeetsumanto123@gmail.com

References
==========

-  https://en.wikipedia.org/wiki/Counting_Bloom_filter
-  https://www.geeksforgeeks.org/counting-bloom-filters-introduction-and-implementation/

Forked from Caravel User Project
================================

|License| |UPRJ_CI| |Caravel Build|

+-------------------+
| ❗ Important Note |
+===================+
+-------------------+

.. _please-fill-in-your-project-documentation-in-this-readmemd-file:

Please fill in your project documentation in this README.md file
----------------------------------------------------------------

Refer to `README <docs/source/index.rst#section-quickstart>`__ for a
quickstart of how to use caravel_user_project

Refer to `README <docs/source/index.rst>`__ for this sample project
documentation.

.. |image| image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/edffcfac-1ee6-44e6-8008-6485fb7b4d9f
.. |image1| image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/5954381f-3fbd-474c-9c6c-7625a42c63af
.. |image2| image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/89b79f3a-c0f9-4bab-b4b8-e8ef9a6c02b1
.. |image3| image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/d777db96-8ee2-4fd8-9f8b-f89a7afab686
.. |image4| image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/31cb2ebd-5747-48bc-b831-e970647a065f
.. |image5| image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/9e95e535-26ba-45a4-96e4-afbfd776fb4f
.. |image6| image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/a9069b65-da50-45d5-9fb0-7b037e5a3f59
.. |image7| image:: https://github.com/Eyantra698Sumanto/caravel_dvsdfossbfc/assets/58599984/969b1c65-c2bc-49fc-9eb2-6f9eac3fe20e
.. |License| image:: https://img.shields.io/badge/License-Apache%202.0-blue.svg
   :target: https://opensource.org/licenses/Apache-2.0
.. |UPRJ_CI| image:: https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml/badge.svg
   :target: https://github.com/efabless/caravel_project_example/actions/workflows/user_project_ci.yml
.. |Caravel Build| image:: https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml/badge.svg
   :target: https://github.com/efabless/caravel_project_example/actions/workflows/caravel_build.yml

